package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.domain.TranRemark;
import com.bjpn.crm.workbench.mapper.TranRemarkMapper;
import com.bjpn.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranRemarkServiceImpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public int saveTranRemark(TranRemark remark) {
        return tranRemarkMapper.insertTranRemark(remark);
    }

    @Override
    public List<TranRemark> queryTranRemarkListForDetail(String id) {
        return tranRemarkMapper.selectTranRemarkListForDetail(id);
    }

    @Override
    public TranRemark queryTranRemarkById(String remarkId) {
        return tranRemarkMapper.selectTranRemarkById(remarkId);
    }

    @Override
    public int saveEditTranRemarkById(TranRemark tranRemark) {
        return tranRemarkMapper.updateEditTranRemarkById(tranRemark) ;
    }
}
