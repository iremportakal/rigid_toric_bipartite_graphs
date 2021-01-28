use application 'polytope';

sub edgeconefromgraph{
    my($graph)=@_;
    my $incidence_matrix = incidence_matrix($graph);
    my $incidencet_matrix = transpose($incidence_matrix);
    my $cone = new Cone(INPUT_RAYS=>$incidencet_matrix);
    return $cone;
}


