public class LibCalendar.SolarHijri : GLib.Object {
    /* Number of days in a cycle */
    const int32 cycle_days = 1029983 ;

    /* Number of years in a cycle */
    const uint16 cycle_years = 2820 ;

    /* 475/01/01 AP, start of 2820 cycle */
    const uint32 hijri_shamsi_epoch = 2121446 ;

    /* 365 + leapRatio */
    const double year_length = 365.24219858156028368 ;

    /* 683.0 / 2820.0 */
    const double leap_threshold = 0.24219858156028368 ;

    int fdiv(int a, int b) {
        return (a - (a < 0 ? b - 1 : 0)) / b ;
    }

    private uint32 floor(uint32 n) {
        return n - (n % 1) ;
    }

    private int mod(int x, int y) {
        return x - fdiv (x, y) * y ;
    }

    private uint16 sh_days_in_year(int16 year) {
        return sh_is_leap (year) ? 366 : 365 ;
    }

    private uint8 sh_month_in_year(int16 year) {
        return 12 ;
    }

    struct division_struct {
        public int quot ;
        public int rem ;
    }

    private division_struct division(int numer, int denom) {
        division_struct result = { 0, 0 } ;
        result.quot = numer / denom ;
        result.rem = numer % denom ;
        return result ;
    }

    private bool sh_is_leap(int16 year) {
        bool output = false ;
        double integral ;
        double frac ;

        frac = Posix.modf ((year + 2346) * leap_threshold, out integral) ;
        if( frac < leap_threshold ){
            output = true ;
        } else {
            output = false ;
        }
        return output ;
    }

    private uint8 sh_days_in_month(uint8 month, int16 year) {
        if( month > 0 && month <= 12 ){
            return month < 7 ? 31 : month < 12 || sh_is_leap (year) ? 30 : 29 ;
        }
        return 0 ;
    }

    private uint32 fdoy_c(int year, int cycleNo) {
        double d_c = (year * year_length) ; /* Day in cycle */
        /* First day of year in a cycle */
        uint32 fdoy_c = (uint32) d_c ;
        return (uint32) (hijri_shamsi_epoch + (int32) cycleNo * (uint32) cycle_days + (uint32) d_c) ;
    }

    division_struct pdiv(int y, int x) {
        division_struct rv = division (y, x) ;
        if( rv.rem < 0 ){
            if( x > 0 ){
                rv.quot -= 1 ;
                rv.rem += x ;
            } else {
                rv.quot += 1 ;
                rv.rem -= x ;
            }
        }
        return rv ;
    }

    private int16 cycle(uint32 jdn) {
        int32 offset = (int32) (jdn - hijri_shamsi_epoch) ;
        int16 cycle_no = (int16) (offset / cycle_days) ;
        if( offset < 0 ){
            --cycle_no ;
        }
        return cycle_no ;
    }

    private uint32 cycle_start(uint32 jdn) {
        int16 era = (int16) cycle (jdn) ;
        uint32 start = hijri_shamsi_epoch + (uint32) era * (uint32) cycle_days ;
        return start ;
    }

    // GR
    public void gr_to_jdn(ref uint32 jd, int16 year, uint8 month, uint16 day) {
        int8 c0 = (int8) fdiv (((int) month - 3), 12) ;
        int16 x1 = (int16) (month - (12 * (int16) c0) - 3) ;
        int16 x4 = (int16) (year + c0) ;
        division_struct d = pdiv ((int) x4, 100) ;
        jd = (uint32) (fdiv (146097 * d.quot, 4)
                       + fdiv (36525 * d.rem, 100)
                       + fdiv (153 * x1 + 2, 5)
                       + day + 1721119) ;
    }

    public void jdn_to_sh(uint32 jd, ref int16 year, ref uint8 month, ref uint16 day) {
        int c = cycle (jd) ;
        int16 y_c = (int16) (floor (jd - cycle_start (jd)) / year_length) ;
        int16 y = y_c + 475 + c * 2820 ;
        uint16 d = (uint16) (jd - fdoy_c (y_c, c)) + 1 ;
        uint8 m = 0 ;
        if( d > sh_days_in_year (y)){
            y++ ;
            d = 1 ;
        }
        if( y <= 0 ){
            y-- ;
        }
        for( m = 1 ; m < 12 ; ++m ){
            if( d > sh_days_in_month (m, y)){
                d -= sh_days_in_month (m, y) ;
            } else {
                break ;
            }
        }
        year = y ;
        month = m ;
        day = d ;
    }

    // SH
    public void sh_to_jdn(ref uint32 jd, int16 year, uint8 month, uint16 day) {
        /* Adjust the offset of year 0 */
        int16 era = 0 ;
        int32 d_y = 0 ;
        int32 y_c = 0 ;
        int32 f_d = 0 ;
        int i = 0 ;

        if( year < 0 ){
            ++year ;
        }
        era = (year - 475) / cycle_years ;
        if((year - 475) < 0 ){
            --era ;
        }

        y_c = (year - 475) - era * cycle_years ;
        f_d = (int32) fdoy_c (y_c, era) ;
        d_y = 0 ;
        for( i = 1 ; i < month ; ++i ){
            d_y += sh_days_in_month ((uint8) i, year) ;
        }
        d_y += day ;
        jd = f_d + d_y - 1 ;
    }

    public void jdn_to_gr(uint32 jd, ref int16 year, ref uint8 month, ref uint16 day) {
        division_struct x3 = pdiv (4 * (int) jd - 6884477, 146097) ;
        division_struct x2 = pdiv (100 * (x3.rem / 4) + 99, 36525) ;
        division_struct x1 = pdiv (5 * (x2.rem / 100) + 2, 153) ;
        int c0 = (x1.quot + 2) / 12 ;
        day = (uint16) (x1.rem / 5) + 1 ;
        month = (uint8) x1.quot - 12 * c0 + 3 ;
        year = (int16) (100 * (int16) x3.quot + (int16) x2.quot + (int16) c0) ;
    }

    // IS
    public void is_to_jdn(ref uint32 jd, int16 year, uint8 month, uint16 day) {
        if( year <= 0 ){
            ++year ;
        }
        jd = fdiv (10631 * year - 10617, 30)
             + fdiv (325 * month - 320, 11)
             + day + 1948439 ;
    }

    private void jdn_to_is(uint32 jd, ref int16 year, ref uint8 month, ref uint16 day) {
        int32 k2 = (int32) (30 * (jd - 1948440) + 15) ;
        int32 k1 = (int32) (11 * fdiv (mod (k2, 10631), 30) + 5) ;
        int16 effective_year = (int16) (fdiv (k2, 10631) + 1) ;
        if( effective_year <= 0 ){
            --effective_year ;
        }
        year = effective_year ;
        month = (uint8) (fdiv (k1, 325) + 1) ;
        day = (uint16) (fdiv (mod (k1, 325), 11) + 1) ;
    }

    // Callable methods
    public void gr_to_sh(int16 gyear, uint8 gmonth, uint16 gday,
                         ref int16 jyear, ref uint8 jmonth, ref uint16 jday) {
        uint32 jdn = 0 ;
        gr_to_jdn (ref jdn, gyear, gmonth, gday) ;
        jdn_to_sh (jdn, ref jyear, ref jmonth, ref jday) ;
    }

    public void sh_to_gr(int16 jyear, uint8 jmonth, uint16 jday,
                         ref int16 gyear, ref uint8 gmonth, ref uint16 gday) {
        uint32 jdn = 0 ;
        sh_to_jdn (ref jdn, jyear, jmonth, jday) ;
        jdn_to_gr (jdn, ref gyear, ref gmonth, ref gday) ;
    }

    public void gr_to_is(int16 gyear, uint8 gmonth, uint16 gday,
                         ref int16 jyear, ref uint8 jmonth, ref uint16 jday) {
        uint32 jdn = 0 ;
        gr_to_jdn (ref jdn, gyear, gmonth, gday) ;
        jdn_to_is (jdn, ref jyear, ref jmonth, ref jday) ;
    }

    construct {

    }
}
