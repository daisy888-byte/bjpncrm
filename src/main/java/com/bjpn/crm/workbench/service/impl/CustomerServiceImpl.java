package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.mapper.CustomerMapper;
import com.bjpn.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<String> queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }
}
