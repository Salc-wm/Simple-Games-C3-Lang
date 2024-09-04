module cst_rl;
import cst;

/* 
 Type of vector arrays directly affects the lifetime and interaction
 int: will last longer than > short: will last longer than char.
 but it could also be just crazy on my part, I didn't do a lot of tests to be sure */
def _Grid = int[<32>][32];

def Table = int[<2>];

const _Grid D_GRID = { [0..32] = {[0..32] = 0} };

struct Grid
{
    int rows, columns;

    _Grid cells;
    int l_cells;
}
