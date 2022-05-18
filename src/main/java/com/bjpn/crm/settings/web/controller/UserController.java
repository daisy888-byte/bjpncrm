package com.bjpn.crm.settings.web.controller;

import com.bjpn.crm.commons.constants.Constants;
import com.bjpn.crm.commons.domain.ReturnObject;
import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public  String toLogin(HttpServletRequest request){

//        System.out.println("=======request.getServletPath()======="+request.getServletPath());
//        System.out.println("=======request.getContextPath()======="+request.getContextPath());
//        HttpSession session = request.getSession(false);
//        if(session==null){
//            System.out.println("===========request.getSession(false)=========session==null=");
//
//        }else {
//            System.out.println("===========request.getSession(false)=========session!=null=");
//        }


        return "settings/qx/user/login";
    }
    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemAct, HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<>();
        ReturnObject returnObject= new ReturnObject();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user = userService.queryUserByActAndPwd(map);
        if(user==null){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或密码不正确！");
        }else {
            if(!user.getAllowIps().contains(request.getRemoteAddr())){
                //ip不在允许范围内
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("ip不在允许范围内！");
            }else if(user.getExpireTime().compareTo(DateUtils.formatDateTime(new Date()))<0){
                //账号已过期
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已过期！");
            }else if("0".equals(user.getLockState())){
                //账号已被锁定
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已被锁定！");
            }else{
                //验证通过
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                //isRemAct
                request.getSession().setAttribute(Constants.SESSION_USER,user);
                if("true".equals(isRemAct)){
                    Cookie c1 = new Cookie("loginAct",loginAct);
                    Cookie c2 = new Cookie("loginPwd",loginPwd);
                    c1.setMaxAge(10*24*60*60);
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c1);
                    response.addCookie(c2);


                }else{
                    Cookie c1 = new Cookie("loginAct","1");
                    Cookie c2 = new Cookie("loginPwd","1");
                    c1.setMaxAge(0);
                    c2.setMaxAge(0);
                    response.addCookie(c1);
                    response.addCookie(c2);

                }
            }

        }

        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletRequest request,HttpServletResponse response){
       //清除cookie，销毁session，返回登录页面
        Cookie c1 = new Cookie("loginAct","1");
        Cookie c2 = new Cookie("loginPwd","1");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);

        request.getSession().invalidate();

        return "redirect:/";

    }


}
