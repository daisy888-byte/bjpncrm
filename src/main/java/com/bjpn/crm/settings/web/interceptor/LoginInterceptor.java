package com.bjpn.crm.settings.web.interceptor;

import com.bjpn.crm.commons.constants.Constants;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
       Object obj = request.getSession().getAttribute(Constants.SESSION_USER);
       if(obj==null){
            response.sendRedirect(request.getContextPath());//
//           request.getRequestDispatcher("/").forward(request,response);  //？？Request URL: http://localhost:8080/crm/workbench/settings/qx/user/toLogin.do

           return false;
       }

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
