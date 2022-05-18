package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    List<Activity> queryByConditionForPage(Map map);

    int queryActivityConditionForCount(Map map);
    int delActivityByIds(String []ids);
    Activity queryActivityById(String id);
    int updateActivityById(Activity activity);

    int saveActivitiesByList(List<Activity> activityList);
    List<Activity> queryAllActivities();

    List<Activity> queryActivitiesByIds(String[] id);

    Activity queryActivityDetailInfoById(String id);

    List<Activity> queryActivitiesByNameAndClueIdNoBund(Map map);


    List<Activity> queryActivitiesByClueIdForList(String clueId);

    List<Activity> queryActivitiesByNameAndClueIdYesBund(Map<String, Object> map);

    List<Activity> queryActivitiesByNameForList(String activityName);
}
