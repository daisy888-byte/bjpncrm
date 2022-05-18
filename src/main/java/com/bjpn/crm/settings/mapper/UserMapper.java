package com.bjpn.crm.settings.mapper;

import com.bjpn.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);
    User queryUserByActAndPwd(Map map);
    List<User> selectAllUsers();


}