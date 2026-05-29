package com.ecommerce.service;

import com.ecommerce.dao.TrialDAO;

public class TrialService {

    private TrialDAO trialDAO = new TrialDAO();

    public boolean requestTrial(String email, String name) {
        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return false;
        }

        // Check if already requested
        if (trialDAO.trialRequestExists(email)) {
            return false;
        }

        // Save trial request
        boolean saved = trialDAO.saveTrialRequest(email, name);

        if (saved) {
            // Here you can add email sending logic
            sendTrialEmail(email);
        }

        return saved;
    }

    private void sendTrialEmail(String email) {
        // Implement email sending logic here
        System.out.println("Trial email sent to: " + email);
    }
}