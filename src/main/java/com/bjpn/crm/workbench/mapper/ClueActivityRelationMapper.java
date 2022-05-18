package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation record);

    int insertSelective(ClueActivityRelation record);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActivityRelation record);

    int updateByPrimaryKey(ClueActivityRelation record);

    int insertClueActivityRelationForList(List<ClueActivityRelation> clueActivityRelationList);

    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> selectByClueIdForList(String clueId);

    int deleteClueActivityRelationByClueId(String clueId);
}