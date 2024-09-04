module gofl_rylib5 @private;
import raylib5::rl;

import cst;
import cst_rl;

const Color GRD_CELL_DEAD = {0, 25, 0, 255};
const Color GRD_CELL_LIFE = {65, 65, 65, 255};

macro void Grid.setValue(Grid* self, Table *grid, int value) => self.cells[grid.x][grid.y] = value;
macro int Grid.getValue(Grid* self, Table grid) => self.cells[grid.x][grid.y];

macro int Grid.getRows(Grid* self) => self.rows;
macro int Grid.getColumns(Grid* self) => self.columns;

macro void Grid.setLivingCells(Grid* self) => self.l_cells++;

fn void Grid.fillRandom(Grid* self) {
    foreach (&row: self.cells) foreach (&column: row) {
        int random_value = rl::getRandomValue(0, 4);
        *column = (random_value == 4)? 1:0;
    }
}

/**
 * @require width > 0, height > 0
 * @return `Grid`
 **/
fn Grid grid(int width, int height) @public @inline => {
    (height - cst::PDG_TOP) / cst::GRD_CELL_SIZE,
    width / cst::GRD_CELL_SIZE, cst_rl::D_GRID, 0
};

macro void Grid.clear(Grid *self) => self.cells = cst_rl::D_GRID;

fn void Grid.toggleCell(Grid* self, Table *grid, char v = 1) @inline => self.setValue(grid, v);

const char CCZ @local = cst::GRD_CELL_SIZE - 2;
const char AC @local = cst::PDG_TOP - 3;

fn void Grid.draw(Grid* self) {
    foreach (char idxr, &row: self.cells) foreach (char idxc, column: *row) {
        int grid_row = idxc * cst::GRD_CELL_SIZE + 6;
        int grid_column = idxr * cst::GRD_CELL_SIZE + AC;

        rl::drawRectangle(
            grid_row, grid_column, CCZ, CCZ,
            column? GRD_CELL_DEAD : GRD_CELL_LIFE
        );
    }
}
