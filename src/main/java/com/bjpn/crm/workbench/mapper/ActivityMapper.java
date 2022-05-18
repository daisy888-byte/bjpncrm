package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    int insertActivity(Activity record);
    List<Activity> selectActivityByConditionForPage(Map map);
    int selectActivityConditionCount(Map map);
    int delActivityByIds(String[]ids);
    Activity selectActivityById(String id);
    int updateActivityById(Activity activity);
    int insertActivitiesByList(List<Activity> activityList);

    List<Activity> selectAllActivities();


    List<Activity> selectActivitiesByIds(String[] id);

    Activity selectActivityDetailInfoById(String id);

    List<Activity> selectActivitiesByNameAndClueIdNoBund(Map map);


    List<Activity> selectActivitiesByClueIdForList(String clueId);

    List<Activity> selectActivitiesByNameAndClueIdYesBund(Map<String, Object> map);

    List<Activity> selectActivitiesByNameForList(String activityName);
}