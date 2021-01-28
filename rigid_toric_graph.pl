use application 'polytope';
use application 'topaz';
use Array::Utils qw(intersect);

sub is_tv_graph_rigid {
    my($cone) = @_;
    my $conedual = new Cone(INPUT_RAYS=>$cone->FACETS);
    my $rays = $conedual->RAYS;
    for (my $i=0; $i < scalar(@{$rays}); $i++) {
        print "a_$i" . " = " . "$rays->[$i]\n\n";
    }
    my $hasse = $conedual->HASSE_DIAGRAM;
    my @bad_threefaces = get_threefaces($hasse, 1);
    if (@bad_threefaces) {
        print "There exist non-simplicial 3-faces: \n";
	print get_threefaces($hasse,1);
        print "\nTV(G) is not rigid.";
        return;
    }
    my $n_v = $cone->AMBIENT_DIM;
    print "Enter " . ($n_v) . " coordinates of a deformation degree R \n";
    my @input = ();
    for (my $i=0; $i < $n_v; $i++) {
    my $in = <STDIN>;
    push @input, $in;
    }
    my $def_degree = new Vector(@input);
    my $crosscut_graph = crosscut_graph($conedual, $hasse, $def_degree);
    my $cnncted = $crosscut_graph->CONNECTED;
    if ($cnncted == 1) {
        print "T1(-[" . $def_degree . "]) is equal to zero";
    }
    else {
        print "T1(-[" . $def_degree . "]) is not equal to zero. Therefore TV(G) is not rigid."
    }
}

sub crosscut_graph {
    my($conedual, $hasse, $def_degree) = @_;
    my @edges = ();
    my @skeleton = crosscut_skeleton($conedual, $hasse, $def_degree);
    for (my $i=0; $i < scalar(@skeleton); $i++) {
        for (my $j=$i + 1; $j < scalar(@skeleton); $j++) {
            my $v = $skeleton[$i];
            my $w = $skeleton[$j];
            my @intersection = intersect(@{$v}, @{$w});
            my $interray = new Vector<Rational>($conedual->RAYS->[$intersection[0]]);
            if (scalar(@intersection) == 2){
                push @edges, [$i, $j];
            }
            elsif (scalar(@intersection) == 1 && $interray * $def_degree > 1){
                push @edges, [$i, $j];
            }
        }
    }
    my $newgraph = graph_from_edges([@edges]);
    return $newgraph;
}

sub crosscut_picture {
    my($conedual,$hasse,$def_degree) = @_;
    my @skeleton = crosscut_skeleton($conedual,$hasse,$def_degree);
    my $simplical_complex = new SimplicialComplex(INPUT_FACES=>[@skeleton]);
    $simplical_complex->VISUAL;
    graphviz($simplical_complex->VISUAL_FACE_LATTICE);
}

sub crosscut_skeleton {
    my($conedual, $hasse, $def_degree) = @_;
    my @skeleton = ();
    my @good_threefaces = get_threefaces($hasse, 0);
    foreach my $gtf (@good_threefaces) {
        my $gen1vec = new Vector<Rational>($conedual->RAYS->[$gtf->[0]]);
        my $gen2vec = new Vector<Rational>($conedual->RAYS->[$gtf->[1]]);
        my $gen3vec = new Vector<Rational>($conedual->RAYS->[$gtf->[2]]);
        my $scproduct1 = $gen1vec * $def_degree;
        my $scproduct2 = $gen2vec * $def_degree;
        my $scproduct3 = $gen3vec * $def_degree;
        if ($scproduct1 >= 1 && $scproduct2 >= 1 && $scproduct3 >= 1) {
            push @skeleton, $gtf;
        }
    }

    my @twofaces = get_twofaces($hasse);
    foreach my $twf (@twofaces) {
        my $gen1vec = new Vector<Rational>($conedual->RAYS->[$twf->[0]]);
        my $gen2vec = new Vector<Rational>($conedual->RAYS->[$twf->[1]]);
        my $scproduct1 = $gen1vec * $def_degree;
        my $scproduct2 = $gen2vec * $def_degree;
        if ($scproduct1 >= 1 && $scproduct2 >= 1) {
            my @subset = grep(/$twf->[0]/ && /$twf->[1]/, @skeleton);
            if(!@subset) {
                push @skeleton, $twf;
            }
        }
    }
    return @skeleton;
}

sub get_threefaces {
    my($hasse, $bad_flag) = @_;
    my @threefaceics = (@{$hasse->nodes_of_dim(3)});
    my @threefaces = ();
    foreach my $tfi (@threefaceics) {
        my $tf = $hasse->FACES->[$tfi];
        if (!$bad_flag && scalar(@{$tf})==3) {
            push @threefaces, $tf;
        } elsif ($bad_flag && scalar(@{$tf})>3) {
            push @threefaces, $tf;
        }
    }
    return @threefaces;
}

sub get_twofaces {
    my($hasse) = @_;
    my @twofaceics = (@{$hasse->nodes_of_dim(2)});
    my @twofaces = ();
    foreach my $tf (@twofaceics) {
        push @twofaces, $hasse->FACES->[$tf];
    }
    return @twofaces;
}

