package com.bjpn.crm.settings.service.impl;

import com.bjpn.crm.settings.domain.DicValue;
import com.bjpn.crm.settings.mapper.DicValueMapper;
import com.bjpn.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCodeForList(String typeCode){
        return dicValueMapper.selectDicValueByTypeCodeForList(typeCode);
    }
}
