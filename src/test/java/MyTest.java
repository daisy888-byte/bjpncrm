import com.bjpn.crm.commons.utils.DateUtils;
import com.bjpn.crm.commons.utils.UUIDUtils;
import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.settings.mapper.UserMapper;
import com.bjpn.crm.workbench.domain.Activity;
import com.bjpn.crm.workbench.mapper.ActivityMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:applicationContext.xml")
public class MyTest {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ActivityMapper activityMapper;
    @Test
    public void test01(){
        Map<String,Object> map = new HashMap<>();

        map.put("loginAct","zs");
        map.put("loginPwd","123");
        User user= userMapper.queryUserByActAndPwd(map);
        System.out.println(user);
    }
    @Test
    public void test02(){
        Activity activity =activityMapper.selectActivityById("82d017accace441abc9b5f4fbb5745a3");
        System.out.println(activity);


    /*    String[]ids= {"'12ee4745257d468d87457eff50fa9d92'"};
//        System.out.println(ids[0]);
        int ret=activityMapper.delActivityByIds(ids);
        System.out.println("=============="+ret);*/


        /*name:name,
        owner:owner,
        startDate:startDate,
        endDate:endDate,
        pageNum:pageNum,
        pageSize:pageSize
        #{startIndex},#{pageSize}
        */
      /*  Map map=new HashMap();
        map.put("owner","张");
            *//* map.put("name","春季");

             map.put("startDate","2022-04-23");
             map.put("endDate","2022-05-23");*//*
             map.put("startIndex",0);
             map.put("pageSize",5);
        System.out.println(activityMapper.selectActivityConditionCount(map));*/
        /*List<Activity> activityList =activityMapper.selectActivityByConditionForPage(map);
        for(Activity activity:activityList){
            System.out.println(activity);
        }*/

    }

//    id, owner, name, start_date, end_date, cost, description, create_time, create_by
   @Test
    public void test03(){
        Activity activity=new Activity();
        activity.setId(UUIDUtils.getUUID());
        activity.setOwner("06f5fc056eac41558a964f96daa7f27c");
        activity.setName("春季44市场活动名称");
        activity.setCreateBy("06f5fc056eac41558a964f96daa7f27c");
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        List<Activity> activityList=new ArrayList<>();
        activityList.add(activity);
       activityMapper.insertActivitiesByList(activityList);

   }



}
