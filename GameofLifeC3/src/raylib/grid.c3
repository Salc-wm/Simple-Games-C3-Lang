module gofl_rylib @private;
import raylib;

import cst;

/* 
 Type of vector arrays directly affects the lifetime and interaction
 int: will last longer than > short: will last longer than char.
 but it could also be just crazy on my part, I didn't do a lot of tests to be sure */
def _Grid = int[<32>][32];

def Table = int[<2>] @public;

const _Grid D_GRID @local = { [0..32] = {[0..32] = 0} };

struct Grid @public
{
    int rows, columns;

    _Grid cells;
    int l_cells;
}

macro void Grid.setValue(Grid* self, Table grid, uint value) => self.cells[grid.x][grid.y] = value;
macro int Grid.getValue(Grid* self, Table grid) => self.cells[grid.x][grid.y];

macro int Grid.getRows(Grid* self) => self.rows;
macro int Grid.getColumns(Grid* self) => self.columns;

fn void Grid.setLivingCells(Grid* self) => self.l_cells++;

fn void Grid.fillRandom(Grid* self) {
    foreach (&row: self.cells) foreach (&column: row) {
        int random_value = raylib::get_random_value(0, 4);
        *column = (random_value == 4)? 1:0;
    }
}

fn Grid grid(uint width, uint height) @public => {
    (height - 80) / cst::GRD_CELL_SIZE,
    width / cst::GRD_CELL_SIZE, D_GRID, 0
};

fn void Grid.clear(Grid *self) => self.cells = D_GRID;

fn void Grid.toggleCell(Grid* self, Table grid, char v = 1) => self.setValue(grid, v);
fn void Grid.hoverCell(Grid* self, Table grid) => self.setValue(grid, 2);

char center_cell_size @local = cst::GRD_CELL_SIZE - 2;
char align_column @local = cst::PDG_TOP - 3;

fn void Grid.draw(Grid* self) {
    // the state is not really necessary, but I will leave it because yes...
    int state;

    foreach (char idxr, row: self.cells) foreach (char idxc, column: row) {
        int grid_row = idxc * cst::GRD_CELL_SIZE + 6;
        int grid_column = idxr * cst::GRD_CELL_SIZE + align_column;

        Color color = (state) < column? cst::GRD_CELL_DEAD : cst::GRD_CELL_LIFE;

        raylib::draw_rectangle(
            grid_row, grid_column,
            center_cell_size, center_cell_size, color
        );

        if (!state && column != 2) continue;

        raylib::draw_rectangle_lines(
            grid_row, grid_column,
            center_cell_size, center_cell_size, raylib::YELLOW
        );

        self.setValue({idxr, idxc}, 0);
    }
}
