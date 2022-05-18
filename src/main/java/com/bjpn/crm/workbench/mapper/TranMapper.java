package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.FunnelVO;
import com.bjpn.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {
    int deleteByPrimaryKey(String id);

    int insert(Tran record);

    int insertSelective(Tran record);

    Tran selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Tran record);

    int updateByPrimaryKey(Tran record);

    int insertTranRecord(Tran tran);

    List<Tran> selectConditionsForpage(Map<String, Object> map);

    int selectByConditionsForTotalRows(Map<String, Object> map);

    Tran selectTranById(String id);


    void updateTranByIdForStageEditInfo(Tran tranUpdateInfo);

    Tran selectTranOriginalById(String id);

    Tran selectTranForEditById(String id);

    int updateTranRecord(Tran tran);

    int deleteTransByIds(String[] id);

    List<Map<String, Object>> selectCountGroupByStage();

    List<FunnelVO> selectCountTranGroupByStage();

    // int updateTranStageById(String id, String orderNo);
}