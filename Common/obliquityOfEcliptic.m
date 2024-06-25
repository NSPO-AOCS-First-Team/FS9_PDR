function epsilon = obliquityOfEcliptic(DT)

jd= DateTime2JD(DT);

T = JDCentury(jd);
epsilon = 23.439291-0.0130042*T;