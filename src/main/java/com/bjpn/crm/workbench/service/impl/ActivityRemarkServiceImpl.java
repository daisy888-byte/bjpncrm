package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.domain.ActivityRemark;
import com.bjpn.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpn.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkByActivityId(String id) {
        return activityRemarkMapper.selectRemarkByActivityId(id);
    }

    @Override
    public int saveCreateRemark(ActivityRemark remark) {
        return activityRemarkMapper.insertRemark(remark);
    }

    @Override
    public int updateActivityRemarkById(ActivityRemark remark) {
        return activityRemarkMapper.updateActivityRemarkById(remark);
    }

    @Override
    public int delActivityRemarkById(String id) {
        return activityRemarkMapper.delActivityRemarkById(id);
    }
}
