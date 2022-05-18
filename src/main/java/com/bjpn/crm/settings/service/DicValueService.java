package com.bjpn.crm.settings.service;

import com.bjpn.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCodeForList(String typeCode);
}
