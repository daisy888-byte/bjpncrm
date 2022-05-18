package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.domain.Contacts;
import com.bjpn.crm.workbench.mapper.ContactsMapper;
import com.bjpn.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Override
    public List<Contacts> queryContactsNameByNameForList(String contactsName) {
        return contactsMapper.selectContactsNameByNameForList( contactsName);
    }
}
