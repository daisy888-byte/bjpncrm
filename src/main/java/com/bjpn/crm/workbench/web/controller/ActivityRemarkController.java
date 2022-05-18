package com.bjpn.crm.workbench.web.controller;

import com.bjpn.crm.commons.constants.Constants;
import com.bjpn.crm.commons.domain.ReturnObject;
import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.workbench.domain.Activity;
import com.bjpn.crm.workbench.domain.ActivityRemark;
import com.bjpn.crm.workbench.service.ActivityRemarkService;
import com.bjpn.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/activityDetail.do")
    public String activityDetail(String id, HttpServletRequest request){
        Activity activity=activityService.queryActivityDetailInfoById(id);
        List<ActivityRemark> remarkList=activityRemarkService.queryActivityRemarkByActivityId(id);

        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",remarkList);

        return "workbench/activity/detail";
    }
    @RequestMapping("/workbench/activity/saveActivityRemarkDetail.do")
    public @ResponseBody Object saveActivityRemarkDetail(ActivityRemark remark, HttpSession session){
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateBy(user.getId());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        ReturnObject returnObject= new ReturnObject();
        try{
            int ret=activityRemarkService.saveCreateRemark(remark);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;

    }
    @RequestMapping("/workbench/activity/updateActivityRemark.do")
    public @ResponseBody Object updateActivityRemark(ActivityRemark remark,HttpSession session){
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditBy(user.getId());

        ReturnObject returnObject=new ReturnObject();
        try {
            int ret=activityRemarkService.updateActivityRemarkById(remark);

            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
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

    @RequestMapping("/workbench/activity/delActivityRemark.do")
    public @ResponseBody Object delActivityRemark(String id){
        ReturnObject returnObject=new ReturnObject();
        try {
            int ret=activityRemarkService.delActivityRemarkById(id);

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

}
