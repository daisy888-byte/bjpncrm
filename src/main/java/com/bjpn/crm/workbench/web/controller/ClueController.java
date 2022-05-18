package com.bjpn.crm.workbench.web.controller;

import com.bjpn.crm.commons.constants.Constants;
import com.bjpn.crm.commons.domain.ReturnObject;
import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.DicValue;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.service.DicValueService;
import com.bjpn.crm.settings.service.UserService;
import com.bjpn.crm.workbench.domain.Activity;
import com.bjpn.crm.workbench.domain.Clue;
import com.bjpn.crm.workbench.domain.ClueActivityRelation;
import com.bjpn.crm.workbench.domain.ClueRemark;
import com.bjpn.crm.workbench.service.ActivityService;
import com.bjpn.crm.workbench.service.ClueActivityRelationService;
import com.bjpn.crm.workbench.service.ClueRemarkService;
import com.bjpn.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request,HttpSession session){
        List<User> userList=userService.queryAllUsers();
        List<DicValue> appellationList= dicValueService.queryDicValueByTypeCodeForList("appellation");
        List<DicValue> clueStateList= dicValueService.queryDicValueByTypeCodeForList("clueState");
        List<DicValue> transactionTypeList= dicValueService.queryDicValueByTypeCodeForList("transactionType");
        List<DicValue> sourceList= dicValueService.queryDicValueByTypeCodeForList("source");
        /*Map<String,Object> map=new HashMap<>();
        map.put("pageStart",0);
        map.put("pageSize",10);
        List<Clue> clueList=clueService.queryByConditionsForPage(map);*/

        request.setAttribute("userList",userList);
        session.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
//        request.setAttribute("clueList",clueList);

        return "workbench/clue/index";
    }
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public @ResponseBody Object saveCreateClue(Clue clue, HttpSession session){

        User user=(User)session.getAttribute(Constants.SESSION_USER);
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject=new ReturnObject();

        try {
            int ret=clueService.saveCreateClue(clue);
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
    @RequestMapping("/workbench/clue/queryClueById.do")
    public @ResponseBody Object queryClueById(String id){
        Clue clue=clueService.queryClueOriginalById(id);

        return clue;
    }
    @RequestMapping("/workbench/clue/updateClueById.do")
    public @ResponseBody Object updateClueById(Clue clue,HttpSession session){
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject=new ReturnObject();
        try {
            int ret=clueService.updateClueById(clue);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

            }else{
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


    @RequestMapping("/workbench/clue/queryByConditionsForPage.do")
    public @ResponseBody Object queryByConditionsForPage(HttpSession session,String name, String  owner, String  company, String   phone, String   mphone, String  state, String  source , int pageNum, int pageSize){
        //String fullname, String  appellation,

        //        fullname, appellation, owner, company,  phone,  mphone, state, source ,pageStart,pageSize
        List<DicValue> appellationList= (List<DicValue>) session.getAttribute("appellationList");

        String appe="";
        String fullname=name;
        String appellation="";
        for(DicValue dv:appellationList){
            appe=dv.getValue();
            if(name.contains(appe)){
                fullname=name.replace(appe,"");
                appellation=dv.getId();
                break;
            }
        }
//        System.out.println("===================="+fullname);
//        System.out.println("===================="+appellation);

        Map<String,Object> map=new HashMap<>();
        map.put("fullname",fullname);
        map.put("appellation",appellation);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);
        map.put("pageStart",(pageNum-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Clue> clueList=clueService.queryByConditionsForPage(map);
        int totalCount=clueService.queryByConditionsForTotalCount(map);

        //clueList:[{},{},],totalCount:XX
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("totalCount",totalCount);
        retMap.put("clueList",clueList);


        return retMap;
    }

    @RequestMapping("/workbench/clue/detail.do")
    public String detail(HttpServletRequest request,String id){
        Clue clue=clueService.queryClueById(id);
        List<ClueRemark> clueRemarkList=clueRemarkService.queryClueRemarksByClueId(id);
        List<Activity> activityList=activityService.queryActivitiesByClueIdForList(id);

        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);

        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public @ResponseBody Object saveCreateClueRemarkBtn(ClueRemark clueRemark,HttpSession session){
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject= new ReturnObject();
        try {
            int ret=clueRemarkService.saveCreateClueRemark(clueRemark);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            }else{
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

    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    public @ResponseBody Object deleteClueRemarkById(String id){
        ReturnObject returnObject= new ReturnObject();

        try {
            int ret=clueRemarkService.deleteClueRemarkById(id);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

            }else{
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
    @RequestMapping("/workbench/clue/queryClueRemarkById.do")
    public @ResponseBody Object queryClueRemarkById(String id){
       ClueRemark clueRemark= clueRemarkService.queryClueRemarkById(id);
       return clueRemark;
    }

    @RequestMapping("/workbench/clue/updateClueRemarkById.do")
    public @ResponseBody Object updateClueRemarkById(ClueRemark clueRemark,HttpSession session){
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);
        ReturnObject returnObject= new ReturnObject();

        try {
            int ret=clueRemarkService.updateClueRemarkById(clueRemark);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            }else{
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
    @RequestMapping("/workbench/clue/queryActivitiesByNameAndClueIdNoBund.do")
    public @ResponseBody Object queryActivitiesByNameAndClueIdNoBund(String activityName,String clueId){
        Map<String,Object> map=new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);


        List<Activity> activityList=activityService.queryActivitiesByNameAndClueIdNoBund(map);
         return   activityList;

    }
    @RequestMapping("/workbench/clue/saveClueActivityRelationForList.do")
    public @ResponseBody Object saveClueActivityRelationForList(String []activityId,String clueId){
        List<ClueActivityRelation> clueActivityRelationList=new ArrayList<>();
        ClueActivityRelation relation=null;
        for(String actId:activityId){
            relation=new ClueActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setActivityId(actId);
            relation.setClueId(clueId);
            clueActivityRelationList.add(relation);
        }
        ReturnObject returnObject=new ReturnObject();
        try {
            int ret=clueActivityRelationService.saveClueActivityRelationForList(clueActivityRelationList);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                List<Activity> activityList=activityService.queryActivitiesByIds(activityId);
                returnObject.setRetData(activityList);

            }else{
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
    @RequestMapping("/workbench/clue/saveUnbund.do")
    public @ResponseBody Object saveUnbund(ClueActivityRelation clueActivityRelation){
        ReturnObject returnObject=new ReturnObject();
        try {
            int ret= clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(clueActivityRelation);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

            }else{
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

    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String clueId,HttpServletRequest request){
        Clue clue=clueService.queryClueById(clueId);
        request.setAttribute("clue",clue);
        return "workbench/clue/convert";
    }
    @RequestMapping("/workbench/clue/tranStage.do")
    public @ResponseBody Object tranStage(){
        List<DicValue> clueStageList= dicValueService.queryDicValueByTypeCodeForList("stage");
        return clueStageList;
    }
    @RequestMapping("/workbench/clue/queryActivityByActivityNameClueId.do")
    public @ResponseBody Object queryActivityByActivityNameClueId(String activityName,String clueId){
        Map<String,Object> map=new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        List<Activity> activityList=activityService.queryActivitiesByNameAndClueIdYesBund(map);

        return activityList;
    }
    @RequestMapping("/workbench/clue/saveClueConvert.do")
    public @ResponseBody Object saveClueConvert(HttpSession session,String money, String name,  String expectedDate, String stage, String activityId, String clueId, String isCreateTransaction){
        //money  name  expectedDate stage activityId clueId isCreateTransaction
        User user=(User)session.getAttribute(Constants.SESSION_USER);
        Map<String,Object> map=new HashMap<>();
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("clueId",clueId);
        map.put("isCreateTransaction",isCreateTransaction);
        map.put("user",user);

        ReturnObject returnObject=new ReturnObject();
        try {
            clueService.saveClueConvert(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;

    }
}
