package com.bjpn.crm.settings.service.impl;

import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.mapper.UserMapper;
import com.bjpn.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
     @Autowired
    private UserMapper userMapper;
     public User queryUserByActAndPwd(Map map){

        return userMapper.queryUserByActAndPwd(map);

     }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }


}
