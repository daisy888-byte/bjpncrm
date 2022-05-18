package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.Customer;
import com.bjpn.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer record);

    int insertSelective(Customer record);

    Customer selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer record);

    int updateByPrimaryKey(Customer record);

    int insertCustomerRecord(Customer customer);
    List<String> selectCustomerByName(String name);

//    Customer selectCustomerByNameNoLike(String customerName);
    Map<String,Object> selectCustomerByNameNoLike(String customerName);


}