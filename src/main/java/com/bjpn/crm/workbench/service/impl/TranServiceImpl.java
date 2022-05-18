package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.commons.constants.Constants;
import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.mapper.DicValueMapper;
import com.bjpn.crm.workbench.domain.Customer;
import com.bjpn.crm.workbench.domain.FunnelVO;
import com.bjpn.crm.workbench.domain.Tran;
import com.bjpn.crm.workbench.domain.TranHistory;
import com.bjpn.crm.workbench.mapper.CustomerMapper;
import com.bjpn.crm.workbench.mapper.TranHistoryMapper;
import com.bjpn.crm.workbench.mapper.TranMapper;
import com.bjpn.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private DicValueMapper dicValueMapper;

    /*@Override
    public void saveTran(Map<String,Object> map) {

        User user=(User)map.get(Constants.SESSION_USER);
        String customerName=(String)map.get("customerName");
        Customer customer=customerMapper.selectCustomerByNameNoLike(customerName);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName((String)map.get("customerName"));
            customerMapper.insertCustomerRecord(customer);
        }
        Tran tran=new Tran();
        tran.setOwner((String)map.get("owner"));
        tran.setType((String)map.get("type"));
        tran.setStage((String)map.get("stage"));
        tran.setNextContactTime((String)map.get("nextContactTime"));
        tran.setName((String)map.get("name"));
        tran.setId(UUIDUtils.getUUID());
        tran.setMoney((String)map.get("money"));
        tran.setExpectedDate((String)map.get("expectedDate"));
        tran.setDescription((String)map.get("description"));
        tran.setCustomerId(customer.getId());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        tran.setCreateBy(user.getId());
        tran.setContactSummary((String)map.get("contactSummary"));
        tran.setContactsId((String)map.get("contactsId"));
        tran.setSource((String)map.get("source"));
        tran.setActivityId((String)map.get("activityId"));


        tranMapper.insertTranRecord(tran);



        return ;
    }*/
    public void saveTranObject(Tran tran,User user,String customerName) {


        Map<String,Object> customerMap=customerMapper.selectCustomerByNameNoLike(customerName);
     //   System.out.println("==================================customerMap=》 "+customerMap);
        Customer customer=null;
        if(customerMap==null){
            customer=new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customerMapper.insertCustomerRecord(customer);
            tran.setCustomerId(customer.getId());
        }else{
            tran.setCustomerId((String) customerMap.get("id"));
        }


        tran.setId(UUIDUtils.getUUID());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        tran.setCreateBy(user.getId());

       // System.out.println("==================================tran.getCustomerId() "+tran.getCustomerId());
        tranMapper.insertTranRecord(tran);

        TranHistory tranHistory=new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());



        tranHistoryMapper.insertTranHistory(tranHistory);

        return;
    }
    public void saveEditTranObject(Tran tran,User user,String customerName) {


        Map<String,Object> customerMap=customerMapper.selectCustomerByNameNoLike(customerName);
        //   System.out.println("==================================customerMap=》 "+customerMap);
        Customer customer=null;
        if(customerMap==null){
            customer=new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customerMapper.insertCustomerRecord(customer);
            tran.setCustomerId(customer.getId());
        }else{
            tran.setCustomerId((String) customerMap.get("id"));
        }


        //tran.setId(UUIDUtils.getUUID());
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtils.formatDateTime(new Date()));
//        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
//        tran.setCreateBy(user.getId());
        System.out.println("==================================tran.getCreateBy() "+tran.getCreateBy());
        System.out.println("==================================tran.getCreateTime() "+tran.getCreateTime());
        System.out.println("==================================tran.getType() "+tran.getType());
        // System.out.println("==================================tran.getCustomerId() "+tran.getCustomerId());
        tranMapper.updateTranRecord(tran);


        TranHistory tranHistory=new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());



        tranHistoryMapper.insertTranHistory(tranHistory);

        return;
    }

    @Override
    public int deleteTransByIds(String[] id) {
        return tranMapper.deleteTransByIds(id);
    }

    @Override
    public List<Map<String, Object>> queryCountGroupByStage() {
        return tranMapper.selectCountGroupByStage();
    }

    @Override
    public List<FunnelVO> queryCountTranGroupByStage() {
        return tranMapper.selectCountTranGroupByStage();
    }

    @Override
    public List<Tran> queryByConditionsForpage(Map<String, Object> map) {
        return tranMapper.selectConditionsForpage(map);
    }

    @Override
    public int queryByConditionsForTotalRows(Map<String, Object> map) {
        return tranMapper.selectByConditionsForTotalRows(map);
    }

    @Override
    public Tran queryTranById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public void saveEditTranStage(String id, String orderNo,User user) {
        ////调service，先查出来stage（order_no  type_code ） id，更新tran阶段，保存历史，
        String stageId= dicValueMapper.selectStageIdByTypeCodeAndOrderNo("stage",orderNo);

//        tranMapper.updateTranStageById(id,stageId);??editby edittime
        Tran tranUpdateInfo=new Tran();
        tranUpdateInfo.setId(id);
        tranUpdateInfo.setEditBy(user.getId());
        tranUpdateInfo.setEditTime(DateUtils.formatDateTime(new Date()));
        tranUpdateInfo.setStage(stageId);

        tranMapper.updateTranByIdForStageEditInfo(tranUpdateInfo);
        Tran tran=tranMapper.selectTranOriginalById(id);

        TranHistory tranHistory=new TranHistory();
        // stage,money,expected_date
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setTranId(id);
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));

        tranHistoryMapper.insertTranHistory(tranHistory);

    }

    @Override
    public Tran queryTranForEditById(String id) {
        return tranMapper.selectTranForEditById(id);
    }

}
