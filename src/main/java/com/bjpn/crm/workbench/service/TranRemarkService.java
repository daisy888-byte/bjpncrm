package com.bjpn.crm.workbench.service;

import com.bjpn.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {
    int saveTranRemark(TranRemark remark);

    List<TranRemark> queryTranRemarkListForDetail(String id);

    TranRemark queryTranRemarkById(String remarkId);

    int saveEditTranRemarkById(TranRemark tranRemark);
}
