package com.bjpn.crm.workbench.mapper;


import com.bjpn.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    int insertSelective(ActivityRemark record);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ActivityRemark record);

    int updateByPrimaryKey(ActivityRemark record);

    List<ActivityRemark> selectRemarkByActivityId(String id);

    int insertRemark(ActivityRemark remark);

    int updateActivityRemarkById(ActivityRemark remark);

    int delActivityRemarkById(String id);
}