function dot_eta = dot_eta_one(eta_two, L_one, q, q_hat)

    dot_eta = eta_two + L_one*(q - q_hat);

end