package com.bjpn.crm.settings.mapper;

import com.bjpn.crm.settings.domain.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue record);

    int insertSelective(DicValue record);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue record);

    int updateByPrimaryKey(DicValue record);
    List<DicValue> selectDicValueByTypeCodeForList(String typeCode);

    String selectStageIdByTypeCodeAndOrderNo(@Param("typeCode") String typeCode, @Param("orderNo")String orderNo);
}