package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int saveClueActivityRelationForList(List<ClueActivityRelation> clueActivityRelationList) ;

    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);
}
