package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(TranRemark record);

    int insertSelective(TranRemark record);

    TranRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TranRemark record);

    int updateByPrimaryKey(TranRemark record);

    int insertTranRemarkForList(List<TranRemark> tranRemarkList);

    int insertTranRemark(TranRemark remark);

    List<TranRemark> selectTranRemarkListForDetail(String id);

    TranRemark selectTranRemarkById(String remarkId);

    int updateEditTranRemarkById(TranRemark tranRemark);
}