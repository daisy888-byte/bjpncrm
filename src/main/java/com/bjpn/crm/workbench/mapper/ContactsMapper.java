package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contacts record);

    int insertSelective(Contacts record);

    Contacts selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contacts record);

    int updateByPrimaryKey(Contacts record);

    int insertContactsRecord(Contacts contacts);

    List<Contacts> selectContactsNameByNameForList(String contactsName);
}