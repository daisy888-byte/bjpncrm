package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueRemark record);

    int insertSelective(ClueRemark record);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark record);

    int updateByPrimaryKey(ClueRemark record);

    int insertClueRemark(ClueRemark clueRemark);

    List<ClueRemark> selectClueRemarks(String clueId);

    int deleteClueRemarkById(String id);

    ClueRemark selectClueRemarkById(String id);

    int updateClueRemarkById(ClueRemark clueRemark);

    List<ClueRemark> selectClueRemarksByClueId(String clueId);

    int deleteClueRemarkByClueId(String clueId);
}