function probability_function = build_mknn_probability_discrete(data, ...
        k, weight_function, pseudocount)

  num_observations = size(data, 1);

  [nearest_neighbors distances] = knnsearch(data, data, 'k', k + 1);

  nearest_neighbors = nearest_neighbors(:, 2:end)';
  nearest_neighbors = logical(sparse(kron((1:num_observations)', ...
          ones(k, 1)), nearest_neighbors(:), 1, num_observations, ...
          num_observations));

  distances = distances(:, 2:end)';
  distances = sparse(kron((1:num_observations)', ones(k, 1)), ...
                     nearest_neighbors(:), distances(:), num_observations, ...
                     num_observations);
  weights = weight_function(distances);

  nearest_neighbors = (nearest_neighbors & nearest_neighbors');
  weights = weights(nearest_neighbors);

  probability_function = @(data, responses, train_ind, test_ind) ...
      knn_probability_discrete(responses, train_ind, test_ind, ...
                               nearest_neighbors, weights, pseudocount);
end