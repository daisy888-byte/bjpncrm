package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.domain.Activity;
import com.bjpn.crm.workbench.mapper.ActivityMapper;
import com.bjpn.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;

    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryByConditionForPage(Map map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryActivityConditionForCount(Map map) {
        return activityMapper.selectActivityConditionCount(map);
    }
    @Override
    public int delActivityByIds(String []ids){
        return activityMapper.delActivityByIds(ids);
    }
    @Override
    public Activity queryActivityById(String id){
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int updateActivityById(Activity activity) {
        return activityMapper.updateActivityById(activity);
    }

    @Override
    public int saveActivitiesByList(List<Activity> activityList) {
        return activityMapper.insertActivitiesByList(activityList);
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    @Override
    public List<Activity> queryActivitiesByIds(String[] id) {
        return activityMapper.selectActivitiesByIds(id);
    }

    @Override
    public Activity queryActivityDetailInfoById(String id) {
        return activityMapper.selectActivityDetailInfoById(id);
    }

    @Override
    public List<Activity> queryActivitiesByNameAndClueIdNoBund(Map map) {
        return activityMapper.selectActivitiesByNameAndClueIdNoBund(map);
    }

    @Override
    public List<Activity> queryActivitiesByClueIdForList(String clueId) {
        return activityMapper.selectActivitiesByClueIdForList(clueId);
    }

    @Override
    public List<Activity> queryActivitiesByNameAndClueIdYesBund(Map<String, Object> map) {
        return activityMapper.selectActivitiesByNameAndClueIdYesBund(map);
    }

    @Override
    public List<Activity> queryActivitiesByNameForList(String activityName) {
        return activityMapper.selectActivitiesByNameForList(activityName);
    }
}
