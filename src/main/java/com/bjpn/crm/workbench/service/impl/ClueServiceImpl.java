package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.workbench.domain.*;
import com.bjpn.crm.workbench.mapper.*;
import com.bjpn.crm.workbench.service.ActivityService;
import com.bjpn.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private  ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryByConditionsForPage(Map map) {
        return clueMapper.selectByConditionsForPage(map);
    }

    @Override
    public int queryByConditionsForTotalCount(Map<String, Object> map) {
        return clueMapper.selectByConditionsForTotalCount( map);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public void saveClueConvert(Map<String, Object> map) {
        //money  name  expectedDate stage activityId clueId isCreateTransaction user
        User user=(User) map.get("user");
        Clue clue=clueMapper.selectClueForConvertById((String)map.get("clueId"));

        //线索 转客户表
        Customer customer=new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setAddress(clue.getAddress());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setDescription(clue.getDescription());
        customer.setEditBy(clue.getEditBy());
        customer.setEditTime(clue.getEditTime());
        customer.setName(clue.getFullname());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customerMapper.insertCustomerRecord(customer);

        //线索 转联系人
        Contacts contacts=new Contacts();
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEditBy(clue.getEditBy());
        contacts.setEditTime(clue.getEditTime());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setId(UUIDUtils.getUUID());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setOwner(user.getId());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setSource(clue.getSource());
        contactsMapper.insertContactsRecord(contacts);

        //线索备注转到客户备注 联系人备注
        List<ClueRemark> clueRemarkList=clueRemarkMapper.selectClueRemarksByClueId((String)map.get("clueId"));
        if(clueRemarkList!=null && clueRemarkList.size()>0){
            CustomerRemark customerRemark=null;
            ContactsRemark contactsRemark=null;
            List<CustomerRemark> customerRemarkList=new ArrayList<>();
            List<ContactsRemark> contactsRemarkList=new ArrayList<>();
            for(ClueRemark clueRemark:clueRemarkList ){
                customerRemark=new CustomerRemark();
                contactsRemark=new ContactsRemark();

                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setCustomerId(customer.getId());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemarkList.add(customerRemark);

                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemarkList.add(contactsRemark);
            }
            customerRemarkMapper.insertCustomerRemarkForList(customerRemarkList);
            contactsRemarkMapper.insertContactsRemarkForList(contactsRemarkList);
        }

        //线索和市场活动关系，转到  联系人和市场活动关系
        List<ClueActivityRelation> clueActivityRelationList=clueActivityRelationMapper.selectByClueIdForList((String)map.get("clueId"));
        if(clueActivityRelationList!=null &&clueActivityRelationList.size()>0){
            ContactsActivityRelation contactsActivityRelation=null;
            List<ContactsActivityRelation> contactsActivityRelationList=new ArrayList<>();
            for(ClueActivityRelation clueActivityRelation:clueActivityRelationList){
                contactsActivityRelation=new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertContactsActivityRelationForList(contactsActivityRelationList);
        }

        //创建交易
        if("true".equals((String)map.get("isCreateTransaction"))){
            //money  name  expectedDate stage activityId clueId isCreateTransaction user
            Tran tran=new Tran();
            tran.setActivityId((String)map.get("activityId"));
            tran.setContactsId(contacts.getId());
            //tran.setContactSummary(clue.getContactSummary());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));
            tran.setCustomerId(customer.getId());
            //tran.setDescription(clue.getDescription());
            tran.setExpectedDate((String)map.get("expectedDate"));
            tran.setMoney((String)map.get("money"));
            tran.setId(UUIDUtils.getUUID());
            tran.setName((String)map.get("name"));
           // tran.setNextContactTime(clue.getNextContactTime());
            tran.setOwner(user.getId());
           // tran.setSource((String)map.get("activityId"));
            tran.setStage((String)map.get("stage"));
            tranMapper.insertTranRecord(tran);

            //clue下备注转到  交易备注表
            if(clueRemarkList!=null && clueRemarkList.size()>0){
                TranRemark tranRemark=null;
                List<TranRemark> tranRemarkList=new ArrayList<>();
                for(ClueRemark clueRemark:clueRemarkList){
                    tranRemark=new TranRemark();
                    tranRemark.setCreateBy(clueRemark.getCreateBy());
                    tranRemark.setCreateTime(clueRemark.getCreateTime());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditFlag(clueRemark.getEditFlag());
                    tranRemark.setEditTime(clueRemark.getEditTime());
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemark.setTranId(tran.getId());

                    tranRemarkList.add(tranRemark);
                }

                tranRemarkMapper.insertTranRemarkForList(tranRemarkList);

            }

        }//true end

        //删备注表，线索-活动关系表，线索
        clueRemarkMapper.deleteClueRemarkByClueId((String)map.get("clueId"));
        clueActivityRelationMapper.deleteClueActivityRelationByClueId((String)map.get("clueId"));
        clueMapper.deleteClueByClueId((String)map.get("clueId"));

    }

    @Override
    public Clue queryClueOriginalById(String id) {
        return clueMapper.selectClueForConvertById(id);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }


}














