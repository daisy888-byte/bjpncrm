package com.bjpn.crm.settings.service;

import com.bjpn.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User queryUserByActAndPwd(Map map);
    List<User> queryAllUsers();


}
