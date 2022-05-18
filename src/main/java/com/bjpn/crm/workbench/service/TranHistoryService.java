package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> queryHistoryListForDetail(String id);
}
