package com.bjpn.crm.workbench.web.controller;

import com.bjpn.crm.commons.constants.Constants;
import com.bjpn.crm.commons.domain.ReturnObject;
import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.HSSFUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.mapper.UserMapper;
import com.bjpn.crm.workbench.domain.Activity;
import com.bjpn.crm.workbench.mapper.ActivityMapper;
import com.bjpn.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ActivityService activityService;


    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> userList=userMapper.selectAllUsers();
        request.setAttribute("userList",userList);

        return "workbench/activity/index";
    }


    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        activity.setCreateBy(user.getId());
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret=activityService.saveCreateActivity(activity);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
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
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,int pageNum,int pageSize ){
        Map map=new HashMap();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("startIndex",(pageNum-1)*pageSize);
        map.put("pageSize",pageSize);

        List<Activity> activityList=activityService.queryByConditionForPage(map);
        int totalRows=activityService.queryActivityConditionForCount(map);
        Map retMap= new HashMap();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }
    @RequestMapping("/workbench/activity/delActivityByIds.do")
    public @ResponseBody Object delActivityByIds(String[]id){
        ReturnObject returnObject= new ReturnObject();

        try {
            int ret=activityService.delActivityByIds(id);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

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

    @RequestMapping("/workbench/activity/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        Activity activity=activityService.queryActivityById(id);
        ReturnObject returnObject= new ReturnObject();
        if(activity!=null){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(activity);
        }else{
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/updateActivityById.do")
    public @ResponseBody Object updateActivityById(Activity activity,HttpSession session){
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        activity.setEditTime(DateUtils.formatDateTime(new Date()));
        activity.setEditBy(user.getId());
        ReturnObject returnObject=new ReturnObject();
        try {
            int ret = activityService.updateActivityById(activity);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
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


    @RequestMapping("/workbench/activity/importActivity.do")
    public @ResponseBody Object importActivity(MultipartFile myFile,HttpSession session){
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject=new ReturnObject();
        try{
            HSSFWorkbook workbook=new HSSFWorkbook(myFile.getInputStream());
            HSSFSheet sheet=workbook.getSheetAt(0);

            Activity activity=null;
            List<Activity> activityList=new ArrayList<>();
            HSSFRow row=null;
            HSSFCell cell=null;
            for (int i=1;i<=sheet.getLastRowNum();i++){
                row=sheet.getRow(i);
                activity=new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());

                cell=row.getCell(0);
                activity.setName(HSSFUtils.cell2String(cell));

                cell=row.getCell(1);
                activity.setStartDate(HSSFUtils.cell2String(cell));

                cell=row.getCell(2);
                activity.setEndDate(HSSFUtils.cell2String(cell));

                cell=row.getCell(3);
                activity.setCost(HSSFUtils.cell2String(cell));

                cell=row.getCell(4);
                activity.setDescription(HSSFUtils.cell2String(cell));

                activityList.add(activity);

            }
           /* for(Activity activity1:activityList){
                System.out.println("======================"+activity1.getId());
            }*/
            int ret=activityService.saveActivitiesByList(activityList);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(ret);
            }else {
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
    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivity(HttpServletResponse response)throws Exception{

//a.id, owner,a.name,a.start_date,a.end_date,a.cost,a.create_time,create_by,a.edit_time,edit_by,a.description
        List<Activity> activityList=activityService.queryAllActivities();
        HSSFWorkbook workbook=new HSSFWorkbook();
        HSSFSheet sheet=workbook.createSheet();
        HSSFRow row=sheet.createRow(0);

        HSSFCell cell=row.createCell(0);
        cell.setCellValue("编号");

        cell=row.createCell(1);
        cell.setCellValue("所有者");

        cell=row.createCell(2);
        cell.setCellValue("名称");

        cell=row.createCell(3);
        cell.setCellValue("开始日期");

        cell=row.createCell(4);
        cell.setCellValue("结束日期");

        cell=row.createCell(5);
        cell.setCellValue("成本");
//a.id, owner,a.name,a.start_date,a.end_date,a.cost,a.create_time,create_by,a.edit_time,edit_by,a.description
        cell=row.createCell(6);
        cell.setCellValue("创建时间");
        cell=row.createCell(7);
        cell.setCellValue("创建者");
        cell=row.createCell(8);
        cell.setCellValue("修改时间");
        cell=row.createCell(9);
        cell.setCellValue("修改者");
        cell=row.createCell(10);
        cell.setCellValue("描述");

        Activity activity=null;
        for(int i=1;i<=activityList.size();i++){
            row=sheet.createRow(i);
            activity=activityList.get(i-1);

            cell=row.createCell(0);
            cell.setCellValue(activity.getId());

            cell=row.createCell(1);
            cell.setCellValue(activity.getOwner());

            cell=row.createCell(2);
            cell.setCellValue(activity.getName());

            cell=row.createCell(3);
            cell.setCellValue(activity.getStartDate());

            cell=row.createCell(4);
            cell.setCellValue(activity.getEndDate());

            cell=row.createCell(5);
            cell.setCellValue(activity.getCost());
//a.id, owner,a.name,a.start_date,a.end_date,a.cost,a.create_time,create_by,a.edit_time,edit_by,a.description
            cell=row.createCell(6);
            cell.setCellValue(activity.getCreateTime());
            cell=row.createCell(7);
            cell.setCellValue(activity.getCreateBy());
            cell=row.createCell(8);
            cell.setCellValue(activity.getEditTime());
            cell=row.createCell(9);
            cell.setCellValue(activity.getEditBy());
            cell=row.createCell(10);
            cell.setCellValue(activity.getDescription());
        }
        OutputStream os=response.getOutputStream();
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList1.xls");

        workbook.write(os);
        workbook.close();
        os.flush();

    }

    @RequestMapping("/workbench/activity/exportXzActivity.do")
    public void exportXzActivity(String[] id,HttpServletResponse response)throws Exception{
        List<Activity> activityList=activityService.queryActivitiesByIds(id);
        HSSFWorkbook workbook=new HSSFWorkbook();
        HSSFSheet sheet=workbook.createSheet();
        HSSFRow row=sheet.createRow(0);

        HSSFCell cell=row.createCell(0);
        cell.setCellValue("编号");

        cell=row.createCell(1);
        cell.setCellValue("所有者");

        cell=row.createCell(2);
        cell.setCellValue("名称");

        cell=row.createCell(3);
        cell.setCellValue("开始日期");

        cell=row.createCell(4);
        cell.setCellValue("结束日期");

        cell=row.createCell(5);
        cell.setCellValue("成本");
//a.id, owner,a.name,a.start_date,a.end_date,a.cost,a.create_time,create_by,a.edit_time,edit_by,a.description
        cell=row.createCell(6);
        cell.setCellValue("创建时间");
        cell=row.createCell(7);
        cell.setCellValue("创建者");
        cell=row.createCell(8);
        cell.setCellValue("修改时间");
        cell=row.createCell(9);
        cell.setCellValue("修改者");
        cell=row.createCell(10);
        cell.setCellValue("描述");

        Activity activity=null;
        for(int i=1;i<=activityList.size();i++){
            row=sheet.createRow(i);
            activity=activityList.get(i-1);

            cell=row.createCell(0);
            cell.setCellValue(activity.getId());

            cell=row.createCell(1);
            cell.setCellValue(activity.getOwner());

            cell=row.createCell(2);
            cell.setCellValue(activity.getName());

            cell=row.createCell(3);
            cell.setCellValue(activity.getStartDate());

            cell=row.createCell(4);
            cell.setCellValue(activity.getEndDate());

            cell=row.createCell(5);
            cell.setCellValue(activity.getCost());
//a.id, owner,a.name,a.start_date,a.end_date,a.cost,a.create_time,create_by,a.edit_time,edit_by,a.description
            cell=row.createCell(6);
            cell.setCellValue(activity.getCreateTime());
            cell=row.createCell(7);
            cell.setCellValue(activity.getCreateBy());
            cell=row.createCell(8);
            cell.setCellValue(activity.getEditTime());
            cell=row.createCell(9);
            cell.setCellValue(activity.getEditBy());
            cell=row.createCell(10);
            cell.setCellValue(activity.getDescription());
        }
        OutputStream os=response.getOutputStream();
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList2.xls");

        workbook.write(os);
        workbook.close();
        os.flush();

    }



}
