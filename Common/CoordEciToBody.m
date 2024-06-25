function Vb = CoordEciToBody(Qa2b,Va)
Qb2a = QInv(Qa2b);
qout = QMul(QMul(Qb2a, [0;Va]), Qa2b);
Vb   = [qout(2) qout(3) qout(4)]';
