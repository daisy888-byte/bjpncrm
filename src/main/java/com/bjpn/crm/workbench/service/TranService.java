package com.bjpn.crm.workbench.service;

import com.bjpn.crm.settings.domain.User;
import com.bjpn.crm.workbench.domain.FunnelVO;
import com.bjpn.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
   // void saveTran(Map<String,Object> map);
    void saveTranObject(Tran tran, User user, String customerName);

    List<Tran> queryByConditionsForpage(Map<String, Object> map);

    int queryByConditionsForTotalRows(Map<String, Object> map);

    Tran queryTranById(String id);

    void saveEditTranStage(String id, String orderNo,User user);

 Tran queryTranForEditById(String id);

 void saveEditTranObject(Tran tran, User user, String customerName);

    int deleteTransByIds(String[] id);

    List<Map<String, Object>> queryCountGroupByStage();

    List<FunnelVO> queryCountTranGroupByStage();
}
