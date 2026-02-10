package com.idoit.util;

import org.springframework.stereotype.Component;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

@Component
public class TxAfterCommit {

    public static void run(Runnable action) {
        if (!TransactionSynchronizationManager.isActualTransactionActive()) {
            // 트랜잭션 없으면 바로 실행
            action.run();
            return;
        }

        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCommit() {
                action.run();
            }
        });
    }
}
