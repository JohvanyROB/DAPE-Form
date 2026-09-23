function hat_dot_q = q_est(u, eta_one, L_two, q, q_hat)

    hat_dot_q = u + eta_one + L_two*(q - q_hat);

end