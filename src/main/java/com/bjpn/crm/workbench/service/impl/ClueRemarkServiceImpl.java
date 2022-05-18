package com.bjpn.crm.workbench.service.impl;

import com.bjpn.crm.workbench.domain.ClueRemark;
import com.bjpn.crm.workbench.mapper.ClueRemarkMapper;
import com.bjpn.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    @Override
    public List<ClueRemark> queryClueRemarksByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarks(clueId);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

    @Override
    public ClueRemark queryClueRemarkById(String id) {
        return clueRemarkMapper.selectClueRemarkById(id);
    }

    @Override
    public int updateClueRemarkById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemarkById(clueRemark);
    }
}
