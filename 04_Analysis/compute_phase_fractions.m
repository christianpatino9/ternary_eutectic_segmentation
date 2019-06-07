function phase_fractions = compute_phase_fractions(label_image)

phases = unique(label_image);
phase_count = numel(phases);
phase_px_counts = nan(size(phases));
for i = 1 : phase_count
    phase = phases(i);
    is_phase = phase == label_image;
    phase_px_counts(i) = sum(is_phase,'all');
end
assert(all(~isnan(phase_px_counts),'all'));

area_px = numel(label_image);
phase_fractions = phase_px_counts ./ area_px;

end

