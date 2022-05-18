package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {
    int deleteByPrimaryKey(String id);

    int insert(TranHistory record);

    int insertSelective(TranHistory record);

    TranHistory selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TranHistory record);

    int updateByPrimaryKey(TranHistory record);

    List<TranHistory> selectHistoryListForDetail(String id);

    int insertTranHistory(TranHistory tranHistory);
}