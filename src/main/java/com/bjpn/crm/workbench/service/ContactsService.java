package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> queryContactsNameByNameForList(String contactsName);
}
