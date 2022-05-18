package com.bjpn.crm.workbench.web.controller;

import com.bjpn.crm.commons.constants.Constants;
import com.bjpn.crm.commons.domain.ReturnObject;
import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.DicValue;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.service.DicValueService;
import com.bjpn.crm.settings.service.UserService;
import com.bjpn.crm.workbench.domain.*;
import com.bjpn.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.*;

@Controller
public class TranController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private TranService tranService;
    @Autowired
    private TranRemarkService tranRemarkService;
    @Autowired
    private TranHistoryService tranHistoryService;

    @RequestMapping("/test2.do")
    public @ResponseBody Object test2(String id){

        return "forward==>"+id;
    }
    @RequestMapping("/test1.do")
    public String test1(String id){

        return "forward:/test2.do";
    }
    @RequestMapping("/test3.do")
    public String test3(String id){

        return "forward:test2.do";
    }


    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        List<DicValue> dicValueStageList=dicValueService.queryDicValueByTypeCodeForList("stage");
        List<DicValue> dicValueTransactionTypeList=dicValueService.queryDicValueByTypeCodeForList("transactionType");
        List<DicValue> dicValueSourceList=dicValueService.queryDicValueByTypeCodeForList("source");

        request.setAttribute("dicValueStageList",dicValueStageList);
        request.setAttribute("dicValueTransactionTypeList",dicValueTransactionTypeList);
        request.setAttribute("dicValueSourceList",dicValueSourceList);
        return "workbench/transaction/index";
    }
    @RequestMapping("/workbench/transaction/queryConditionsForPage.do")
    public @ResponseBody Object queryConditionsForPage(@RequestParam Map<String,Object> map){

            Integer pageNum=Integer.valueOf((String)map.get("pageNum"));
            Integer pageSize=Integer.valueOf((String)map.get("pageSize"));
            map.put("pageIndex",(pageNum-1)*pageSize);
            map.remove("pageSize");
            map.put("pageSize",pageSize);
            List<Tran> tranList=tranService.queryByConditionsForpage(map);
            int totalRows=tranService.queryByConditionsForTotalRows(map);
            Map<String,Object> retMap=new HashMap<>();
            retMap.put("tranList",tranList);
            retMap.put("totalRows",totalRows);

            return retMap;
    }

    @RequestMapping("/workbench/transaction/createTran.do")
    public String createTran(HttpServletRequest request){

        List<User> userList=userService.queryAllUsers();
        List<DicValue> dicValueStageList=dicValueService.queryDicValueByTypeCodeForList("stage");
        List<DicValue> dicValueTransactionTypeList=dicValueService.queryDicValueByTypeCodeForList("transactionType");
        List<DicValue> dicValueSourceList=dicValueService.queryDicValueByTypeCodeForList("source");

        request.setAttribute("userList",userList);
        request.setAttribute("dicValueStageList",dicValueStageList);
        request.setAttribute("dicValueTransactionTypeList",dicValueTransactionTypeList);
        request.setAttribute("dicValueSourceList",dicValueSourceList);


        return "workbench/transaction/save";
    }
    @RequestMapping("/workbench/transaction/queryCustomerByName.do")
    public @ResponseBody Object queryCustomerByName(String name){
        List<String> names=customerService.queryCustomerByName(name);
        return  names;
    }
    @RequestMapping("/workbench/transaction/getStagePossibility.do")
    public @ResponseBody Object getStagePossibility(String stageName, HttpServletRequest request){
        String path=request.getServletContext().getRealPath("/userConfig");
        String file=path+File.separator+"possibility.properties";
        String value=null;
        try {
            FileReader reader=new FileReader(file);
            Properties properties=new Properties();
            properties.load(reader);
            value=properties.getProperty(stageName);

        } catch (Exception e) {
            e.printStackTrace();

        }
        return value;

    }
    @RequestMapping("/workbench/transaction/queryContactsName.do")
    public @ResponseBody Object queryContactsName(String contactsName){
        List<Contacts> contactsList=contactsService.queryContactsNameByNameForList(contactsName);
        return contactsList;

    }
    @RequestMapping("/workbench/transaction/queryActivityName.do")
    public @ResponseBody Object queryActivityName(String activityName){
        List<Activity> activityList=activityService.queryActivitiesByNameForList(activityName);
        return activityList;

    }
    /*@RequestMapping("/workbench/transaction/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(@RequestParam Map<String,Object> map,HttpSession session){

        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        ReturnObject returnObject=new ReturnObject();
        try {
            tranService.saveTran(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;
    }*/
    @RequestMapping("/workbench/transaction/saveCreateTranObject.do")
    public @ResponseBody Object saveCreateTranObject(Tran tran,HttpSession session,String customerName){
          User user=(User)session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject=new ReturnObject();
        try {
          tranService.saveTranObject(tran,user,customerName);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;


    }
    @RequestMapping("/workbench/transaction/saveEditTranObject.do")
    public @ResponseBody Object saveEditTranObject(Tran tran,HttpSession session,String customerName){
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject=new ReturnObject();
        try {
            tranService.saveEditTranObject(tran,user,customerName);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;


    }

    @RequestMapping("/workbench/transaction/tranDetail.do")
    public String  tranDetail(String id,HttpServletRequest request){
       // System.out.println("转发后id============================》"+id);
       Tran tran= tranService.queryTranById(id);
       List<TranRemark>  tranRemarkList=tranRemarkService.queryTranRemarkListForDetail(id);
       List<TranHistory> tranHistoryList=tranHistoryService.queryHistoryListForDetail(id);
        List<DicValue> stageList=dicValueService.queryDicValueByTypeCodeForList("stage");

        try {
            String fileName=request.getRealPath("/userConfig")+ File.separator+"possibility.properties";
            FileReader reader=new FileReader(fileName);
            Properties pro=new Properties();
            pro.load(reader);
            String poss=pro.getProperty(tran.getStage());
            tran.setPossibility(poss);

        } catch (Exception e) {
            e.printStackTrace();
        }


        request.setAttribute("stageList",stageList);
        request.setAttribute("tran",tran);
        request.setAttribute("tranRemarkList",tranRemarkList);
        request.setAttribute("tranHistoryList",tranHistoryList);

        return "workbench/transaction/detail";
    }
    @RequestMapping("/workbench/transaction/saveTranRemark.do")
    public @ResponseBody Object saveTranRemark(TranRemark remark,HttpSession session){
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        System.out.println("============================"+remark.getTranId());
        ReturnObject returnObject=new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setCreateBy(user.getId());
        try {
            int ret=tranRemarkService.saveTranRemark(remark);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(remark);

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/transaction/stageUpdate.do")
    public String stageUpdate(String id,String orderNo,HttpSession session){
       // System.out.println("接收到id============================》"+id);
        //调service，更新tran阶段，保存历史，
        User user=(User)session.getAttribute(Constants.SESSION_USER);

        try {
            tranService.saveEditTranStage(id,orderNo,user);

        } catch (Exception e) {
            e.printStackTrace();

        }

        //System.out.println("转发前id============================》"+id);
       // request.setAttribute("id",id);
        return "forward:/workbench/transaction/tranDetail.do";
    }
    @RequestMapping("/workbench/transaction/queryTranRemarkById.do")
    public @ResponseBody Object queryTranRemarkById(String remarkId){
            TranRemark tranRemark=tranRemarkService.queryTranRemarkById(remarkId);
            return tranRemark;
    }
    @RequestMapping("/workbench/transaction/saveEditTranRemarkById.do")
    public @ResponseBody Object saveEditTranRemarkById(TranRemark tranRemark,HttpSession session){
        tranRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        tranRemark.setEditBy(((User)session.getAttribute(Constants.SESSION_USER)).getId());
        tranRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);

        ReturnObject returnObject=new ReturnObject();
        try {
            int ret=tranRemarkService.saveEditTranRemarkById(tranRemark);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(tranRemark);

            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试....");
            }

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }
    @RequestMapping("/workbench/transaction/queryTranById.do")
    public String queryTranById(String id,HttpServletRequest request){
        //查下拉列表框，查数据 //修改数据，注意同时插入一条历史记录
        Tran tran=tranService.queryTranForEditById(id);
        List<DicValue> stageList=dicValueService.queryDicValueByTypeCodeForList("stage");
        List<DicValue> tranTypeList=dicValueService.queryDicValueByTypeCodeForList("transactionType");
        List<DicValue> sourceList=dicValueService.queryDicValueByTypeCodeForList("source");
        List<User> userList= userService.queryAllUsers();


        try {
            String name=request.getRealPath("/userConfig")+File.separator+"possibility.properties";
            FileReader fileReader=new FileReader(name);
            Properties prop=new Properties();
            prop.load(fileReader);
            String poss=prop.getProperty(tran.getStage());
            tran.setPossibility(poss);

        } catch (Exception e) {
            e.printStackTrace();
        }


        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("userList",userList);
        request.setAttribute("tran",tran);

        return "workbench/transaction/edit";
    }
    @RequestMapping("/workbench/transaction/queryActivitiesByNameForList.do")
    public @ResponseBody Object queryActivitiesByNameForList(String activityName){
        List<Activity> activityList= activityService.queryActivitiesByNameForList(activityName);

        return activityList;
    }
    @RequestMapping("/workbench/transaction/queryContactsByNameForList.do")
    public @ResponseBody Object queryContactsByNameForList(String contactsName){
        List<Contacts> contactsList= contactsService.queryContactsNameByNameForList(contactsName);
        return contactsList;
    }
    @RequestMapping("/workbench/transaction/deleteTransByIds.do")
    public @ResponseBody Object deleteTransByIds(String[]id){

        ReturnObject returnObject=new ReturnObject();
        try{

            int ret=tranService.deleteTransByIds(id);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);


            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试....");
            }

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
            return returnObject;
    }
    @RequestMapping("/workbench/transaction/tranFunnel.do")
    public String tranFunnel(){

        return "workbench/transaction/tranFunnel";
    }
    @RequestMapping("/workbench/transaction/stageCountForChart.do")
    public @ResponseBody Object stageCountForChart(){
        List<Map<String,Object>> dataCount=tranService.queryCountGroupByStage();
        return dataCount;
    }
    @RequestMapping("/workbench/transaction/stageCountTranGroupByStageForChart.do")
    public @ResponseBody Object stageCountTranGroupByStageForChart(){
        List<FunnelVO> funnelVOList=tranService.queryCountTranGroupByStage();
        return funnelVOList;
    }

}
