package com.bjpn.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
public class IndexController {

   @RequestMapping(value = "/testpy6",produces = "text/html;charset=utf-8")//这里添加备注了testpy6
    public @ResponseBody Object testpy6(){ //测试io读文件，打印
        FileInputStream fis=null;
        try {
            fis= new FileInputStream("/Users/apple/PycharmProjects/myPythonMay/a_1.txt");
            byte[] bytes=new byte[8];
            int count=0;
            String str="";
            while((count=fis.read(bytes))!=-1){
                System.out.println(count);
                str=new String(bytes,0,count);
                System.out.println(str);
            }


        } catch (Exception e) {
            e.printStackTrace();
            try {
                fis.close();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }

        return "看打印内容";//
    }

  /*测试备注1
    @RequestMapping(value = "/testpy4",produces="text/plain;charset=utf-8")
    public @ResponseBody Object testpy4(){
        Map<String,Object> map=new HashMap<>();
        map.put("name","张三");
        map.put("sex","male");
        map.put("age",20);
        return "<input type='text' value='aaa'/>";

    }
    @RequestMapping(value = "/testpy5",produces="application/json;charset=utf-8")
    public @ResponseBody Object testpy5(){
        Map<String,Object> map=new HashMap<>();
        map.put("name","张三");
        map.put("sex","male");
        map.put("age",20);
        //return "<input type='text' value='aaa'/>";
        return map;
    }



    @RequestMapping("/testpy")
    public @ResponseBody Object testpy(HttpServletRequest request){
        Cookie[] cks=request.getCookies();
        String v=cks[0].getValue();
        String ret="";
        if("zhangsan".equals(v)){
            ret="hello,zhangsan";
        }else {
            ret="hello,other people.";
        }

        return ret;
    }

    @RequestMapping("/testpy2")
    public String testpy2(){
        return "redirect:/testpy1";
    }
    @RequestMapping("/testpy1")
    public  @ResponseBody Object testpy1(){
        return "hello,dear my python";
    }*/

    @RequestMapping("/")
    public  String index(){
        return "index";
    }
}
