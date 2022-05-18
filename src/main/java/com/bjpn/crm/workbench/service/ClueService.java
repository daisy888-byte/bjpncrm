package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.Clue;
import com.bjpn.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int saveCreateClue(Clue clue);
    List<Clue> queryByConditionsForPage(Map map);

    int queryByConditionsForTotalCount(Map<String, Object> map);

    Clue queryClueById(String id);


    void saveClueConvert(Map<String, Object> map);

    Clue queryClueOriginalById(String id);

    int updateClueById(Clue clue);
}
