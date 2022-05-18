package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    int saveCreateClueRemark(ClueRemark clueRemark);

    List<ClueRemark> queryClueRemarksByClueId(String clueId);

    int deleteClueRemarkById(String id);

    ClueRemark queryClueRemarkById(String id);

    int updateClueRemarkById(ClueRemark clueRemark);
}
