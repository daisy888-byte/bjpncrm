package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkByActivityId(String id);

    int saveCreateRemark(ActivityRemark remark);

    int updateActivityRemarkById(ActivityRemark remark);

    int delActivityRemarkById(String id);
}
