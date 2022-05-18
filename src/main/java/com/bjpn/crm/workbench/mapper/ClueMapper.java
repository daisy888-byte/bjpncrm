package com.bjpn.crm.workbench.mapper;

import com.bjpn.crm.workbench.domain.Clue;
import com.bjpn.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    int insertClue(Clue clue);

    List<Clue> selectByConditionsForPage(Map map);

    int selectByConditionsForTotalCount(Map<String, Object> map);

    Clue selectClueById(String id);


    Clue selectClueForConvertById(String clueId);

    int deleteClueByClueId(String clueId);


    int updateClueById(Clue clue);
}