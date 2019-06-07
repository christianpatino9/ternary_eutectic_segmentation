function compute_phase_fractions_test()

phases = [1,2,4];
phase_count = numel(phases);
padding = 10;
im_size = phase_count .* padding;
test_image = nan(im_size,im_size);
for i = 1 : phase_count
    phase = phases(i);
    start = 1 + padding * ( i - 1 );
    finish = padding * i;
    test_image( start : finish, : ) = phase;
end

shuffled_indices = randperm( numel( test_image ), numel( test_image ) );
test_image = reshape( test_image( shuffled_indices ), size( test_image ) );

pf = compute_phase_fractions( test_image );
fprintf( 1, '%f\n', pf );

% TODO: check out matlab unit testing
% satisfiedBy()

end

