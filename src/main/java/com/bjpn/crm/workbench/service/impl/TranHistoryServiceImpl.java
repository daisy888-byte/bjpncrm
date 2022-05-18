package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.domain.TranHistory;
import com.bjpn.crm.workbench.mapper.TranHistoryMapper;
import com.bjpn.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    private TranHistoryMapper historyMapper;
    @Override
    public List<TranHistory> queryHistoryListForDetail(String id) {
        return historyMapper.selectHistoryListForDetail(id);
    }
}
